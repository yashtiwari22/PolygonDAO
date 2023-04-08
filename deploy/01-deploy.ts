import { HardhatRuntimeEnvironment } from "hardhat/types";
import {DeployFunction} from "hardhat-deploy/types"

const deployPolygonDAO: DeployFunction =async function(
  hre:HardhatRuntimeEnvironment
){
  const {getNamedAccounts,deployments,network} =hre;
  const {deploy,log}=deployments;
  const {deployer}=await getNamedAccounts();
  console.log("Deploying....");
  const polygonDAO=await deploy("PolygonDAO",{
    from:deployer,
    args:[],
    log:true
  });

}
export default deployPolygonDAO;