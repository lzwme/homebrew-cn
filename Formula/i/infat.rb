class Infat < Formula
  desc "Tool to set default openers for file formats and url schemes on macOS"
  homepage "https://github.com/philocalyst/infat"
  url "https://ghfast.top/https://github.com/philocalyst/infat/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "c931cc909c98cabe24e6ee92f10e9fc45941499f4e07e4f201bcc6c9aa910a7d"
  license "MIT"
  head "https://github.com/philocalyst/infat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe6f1a78d38e982b0fd8d23361d716b1e83dcc3d1d8315a65d1767198467ab4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5df6d527ed3a5469b149cf0760fb54efdc7a696b093aa4535de5c1e8cfc1c401"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9357f7f53cee6c3bb35fc3b1ddf8ec6b4138f157ec57ccc63bf0bc364cac140"
    sha256 cellar: :any_skip_relocation, sonoma:        "9de06ae326145af75483ab8334e35a35bb24ca56cd502638df23e0edb493fc80"
  end

  depends_on "rust" => :build
  depends_on :macos
  depends_on macos: :sonoma

  def install
    system "cargo", "install", *std_cargo_args(path: "infat-cli")

    bash_completion.install "target/release/infat.bash"
    fish_completion.install "target/release/infat.fish"
    zsh_completion.install "target/release/_infat"
  end

  test do
    output = shell_output("#{bin}/infat set TextEdit --ext txt")
    assert_match "Set .txt", output
  end
end