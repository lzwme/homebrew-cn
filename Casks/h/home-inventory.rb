cask "home-inventory" do
  version "3.8.6,20210517"
  sha256 :no_check

  url "https://binaryformations.com/homeinventory/HomeInventory.dmg"
  name "Home Inventory"
  desc "Documentation application for home and belongings"
  homepage "https://binaryformations.com/products/home-inventory/"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-04", because: :discontinued
  disable! date: "2025-07-04", because: :discontinued

  depends_on macos: ">= :sierra"

  app "Home Inventory.app"
end