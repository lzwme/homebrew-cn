class Oxker < Formula
  desc "Terminal User Interface (TUI) to view & control docker containers"
  homepage "https:github.commrjackwillsoxker"
  url "https:github.commrjackwillsoxkerarchiverefstagsv0.8.0.tar.gz"
  sha256 "1229551e6be813332679a523a834b9134d4351a1b0dec9b1f02f9af62a745128"
  license "MIT"
  head "https:github.commrjackwillsoxker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b52fb9b01dfb69b17e0cda31d2313b581a92bd1af40681f9e24c5ddcace8147"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "830947755fc912b9908e9253e5c2933e5a95985b5224dabbdb67fd75f507c7c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6aea26b96ad5998b705db7554f70a1c7aa58c3a51fdbf738c346a356e2f86edd"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a5267243b85857956266472e7afc5cd69e5faada5fb18e9d430e767804922b0"
    sha256 cellar: :any_skip_relocation, ventura:       "86628003e90fe7e99a2e9387a961b2e0aad2406a8c293cab42f42bb642a98ceb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03ccb522a1248b1d04549f3a0f773806424090da9709a5561a6b19254c855cb7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output(bin"oxker --version")

    assert_match "a value is required for '--host <HOST>' but none was supplied",
      shell_output(bin"oxker --host 2>&1", 2)
  end
end