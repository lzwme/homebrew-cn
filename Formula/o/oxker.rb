class Oxker < Formula
  desc "Terminal User Interface (TUI) to view & control docker containers"
  homepage "https:github.commrjackwillsoxker"
  url "https:github.commrjackwillsoxkerarchiverefstagsv0.10.1.tar.gz"
  sha256 "317b9b28c722f776a07006d94020a8ff5d2ffd90a578aa0b6f5cef2eef69df57"
  license "MIT"
  head "https:github.commrjackwillsoxker.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f968eda42daec800e223d157103a29f7265a030ef4495465fd943eafa98f50de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f880c5fd96de5773d26d8a7bfa1c67a6433e8510faef43dab101a3381ed77601"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5d1cc216d37eacbe46296697acb8823f0eca6486f6136400af1fb5d0a4b5d078"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f95d9ce4c655ab2d4bef522048d177ffdf1143f28b8b396996125b53b796466"
    sha256 cellar: :any_skip_relocation, ventura:       "69e0f82b9f0c7745a895bfeaa1e983d0876ad7dafb639bb7407c19e7c6cdc1a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e90a26a6da0ea5636eaa622a34146777ea95ee9325a4f02b0979ed07a3904e3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b87a7ce2c3f997ebd641e24a671e3090b6fecbf0b411d43de16b8cbba8c67020"
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