class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.24.5.tar.gz"
  sha256 "a5ad3f00a1b17d61c50e37cfab7da72d2e4651997a4874c9f07e1b4e301fae03"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "cc7ce754848071f92421e7602ab883d8fe337be3e3c65b95adb0a1bd4e0a66a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7f97e9e49b054eec64955408fe9a052e016aa84fb5d03f975169a851334f5c19"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4851aeeefe46d90e66adeb9793f166bd145a6bb41f1b6d9f956bf2e49bfe8a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a32725150fd1eb90fd699c1cfec572fbf7c346c6112fef83b4ea4dd8e5120a3"
    sha256 cellar: :any_skip_relocation, sonoma:         "88783508e8b77850095a6ef003ccacf856e1b024f0e2bac39e087a7eea369bb8"
    sha256 cellar: :any_skip_relocation, ventura:        "0a812f83cc5364a1f7cbceca7ebfc1a815d54ee42e1b09ec887fcf074270eff4"
    sha256 cellar: :any_skip_relocation, monterey:       "a2607070d767f7b155817e2728447e5ddf9242299e3ac22d14aaf14dd0c0c8a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d3566458caf5d5963f943bf348b7e73198650c37c151a46dc9ac616d54a8f70"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratestypos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}typos -", "teh", 2)
    assert_empty pipe_output("#{bin}typos -", "the")
  end
end