{-# LANGUAGE BangPatterns, DeriveDataTypeable, FlexibleInstances, MultiParamTypeClasses #-}
{-# OPTIONS_GHC  -fno-warn-unused-imports #-}
module Crypto.Lol.Types.Proto.CycMsg (CycMsg(..)) where
import Prelude ((+), (/))
import qualified Prelude as Prelude'
import qualified Data.Typeable as Prelude'
import qualified Data.Data as Prelude'
import qualified Text.ProtocolBuffers.Header as P'
import qualified Crypto.Lol.Types.Proto.Basis as Lol.CycMsg (Basis)
import qualified Crypto.Lol.Types.Proto.TensorMsg as Lol (TensorMsg)

data CycMsg = CycMsg{basis :: !(Lol.CycMsg.Basis), tensor :: !(Lol.TensorMsg)}
            deriving (Prelude'.Show, Prelude'.Eq, Prelude'.Ord, Prelude'.Typeable, Prelude'.Data)

instance P'.Mergeable CycMsg where
  mergeAppend (CycMsg x'1 x'2) (CycMsg y'1 y'2) = CycMsg (P'.mergeAppend x'1 y'1) (P'.mergeAppend x'2 y'2)

instance P'.Default CycMsg where
  defaultValue = CycMsg P'.defaultValue P'.defaultValue

instance P'.Wire CycMsg where
  wireSize ft' self'@(CycMsg x'1 x'2)
   = case ft' of
       10 -> calc'Size
       11 -> P'.prependMessageSize calc'Size
       _ -> P'.wireSizeErr ft' self'
    where
        calc'Size = (P'.wireSizeReq 1 14 x'1 + P'.wireSizeReq 1 11 x'2)
  wirePut ft' self'@(CycMsg x'1 x'2)
   = case ft' of
       10 -> put'Fields
       11 -> do
               P'.putSize (P'.wireSize 10 self')
               put'Fields
       _ -> P'.wirePutErr ft' self'
    where
        put'Fields
         = do
             P'.wirePutReq 8 14 x'1
             P'.wirePutReq 18 11 x'2
  wireGet ft'
   = case ft' of
       10 -> P'.getBareMessageWith update'Self
       11 -> P'.getMessageWith update'Self
       _ -> P'.wireGetErr ft'
    where
        update'Self wire'Tag old'Self
         = case wire'Tag of
             8 -> Prelude'.fmap (\ !new'Field -> old'Self{basis = new'Field}) (P'.wireGet 14)
             18 -> Prelude'.fmap (\ !new'Field -> old'Self{tensor = P'.mergeAppend (tensor old'Self) (new'Field)}) (P'.wireGet 11)
             _ -> let (field'Number, wire'Type) = P'.splitWireTag wire'Tag in P'.unknown field'Number wire'Type old'Self

instance P'.MessageAPI msg' (msg' -> CycMsg) CycMsg where
  getVal m' f' = f' m'

instance P'.GPB CycMsg

instance P'.ReflectDescriptor CycMsg where
  getMessageInfo _ = P'.GetMessageInfo (P'.fromDistinctAscList [8, 18]) (P'.fromDistinctAscList [8, 18])
  reflectDescriptorInfo _
   = Prelude'.read
      "DescriptorInfo {descName = ProtoName {protobufName = FIName \".Lol.CycMsg\", haskellPrefix = [], parentModule = [MName \"Lol\"], baseName = MName \"CycMsg\"}, descFilePath = [\"Lol\",\"CycMsg.hs\"], isGroup = False, fields = fromList [FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".Lol.CycMsg.basis\", haskellPrefix' = [], parentModule' = [MName \"Lol\",MName \"CycMsg\"], baseName' = FName \"basis\", baseNamePrefix' = \"\"}, fieldNumber = FieldId {getFieldId = 1}, wireTag = WireTag {getWireTag = 8}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 14}, typeName = Just (ProtoName {protobufName = FIName \".Lol.CycMsg.Basis\", haskellPrefix = [], parentModule = [MName \"Lol\",MName \"CycMsg\"], baseName = MName \"Basis\"}), hsRawDefault = Nothing, hsDefault = Nothing},FieldInfo {fieldName = ProtoFName {protobufName' = FIName \".Lol.CycMsg.tensor\", haskellPrefix' = [], parentModule' = [MName \"Lol\",MName \"CycMsg\"], baseName' = FName \"tensor\", baseNamePrefix' = \"\"}, fieldNumber = FieldId {getFieldId = 2}, wireTag = WireTag {getWireTag = 18}, packedTag = Nothing, wireTagLength = 1, isPacked = False, isRequired = True, canRepeat = False, mightPack = False, typeCode = FieldType {getFieldType = 11}, typeName = Just (ProtoName {protobufName = FIName \".Lol.TensorMsg\", haskellPrefix = [], parentModule = [MName \"Lol\"], baseName = MName \"TensorMsg\"}), hsRawDefault = Nothing, hsDefault = Nothing}], descOneofs = fromList [], keys = fromList [], extRanges = [], knownKeys = fromList [], storeUnknown = False, lazyFields = False, makeLenses = False}"

instance P'.TextType CycMsg where
  tellT = P'.tellSubMessage
  getT = P'.getSubMessage

instance P'.TextMsg CycMsg where
  textPut msg
   = do
       P'.tellT "basis" (basis msg)
       P'.tellT "tensor" (tensor msg)
  textGet
   = do
       mods <- P'.sepEndBy (P'.choice [parse'basis, parse'tensor]) P'.spaces
       Prelude'.return (Prelude'.foldl (\ v f -> f v) P'.defaultValue mods)
    where
        parse'basis
         = P'.try
            (do
               v <- P'.getT "basis"
               Prelude'.return (\ o -> o{basis = v}))
        parse'tensor
         = P'.try
            (do
               v <- P'.getT "tensor"
               Prelude'.return (\ o -> o{tensor = v}))