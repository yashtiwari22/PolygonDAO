import { ethers } from 'hardhat';

async function main() {
  const dao = await ethers.getContract("PolygonDAO");
  // Apply for membership
  const [member1, member2] = await ethers.getSigners();
  await dao.applyForMembership();
  await dao.connect(member1).applyForMembership();

  //Approve a member
  await dao.approveMembership(member1.address);
  console.log(`${member1.address} approved as a member`);
}

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });
