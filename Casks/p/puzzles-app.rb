cask "puzzles-app" do
  version "20241108"
  sha256 :no_check

  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/Puzzles.dmg"
  name "Simon Tatham's Portable Puzzle Collection"
  desc "Collection of small computer programmes which implement one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-11-18", because: :discontinued, replacement_formula: "puzzles"

  app "Puzzles.app"

  zap trash: [
    "~/Library/Caches/com.apple.helpd/Generated/Puzzles Help*",
    "~/Library/Saved Application State/uk.org.greenend.chiark.sgtatham.puzzles.savedState",
  ]
end