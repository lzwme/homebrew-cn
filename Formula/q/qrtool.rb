class Qrtool < Formula
  desc "Utility for encoding or decoding QR code"
  homepage "https:sorairolake.github.ioqrtool"
  url "https:github.comsorairolakeqrtoolarchiverefstagsv0.11.0.tar.gz"
  sha256 "a33de0fbced3531157b0a5541a3d137b0646286b1f742941def3b685560026a5"
  license all_of: [
    "CC-BY-4.0",
    any_of: ["Apache-2.0", "MIT"],
  ]
  head "https:github.comsorairolakeqrtool.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b71f69c88ddec5326d8a2f11deeecbcb8e69bc3253552bb16eb821f0402ec68c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a63df9666f30a408f4521e74576454f7e5ca62dadae38fd25f2c2e00d89d7018"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12d796580bcf2e90e2f9b2f88079f0a5111e4626cf04177fb0e483da38117a8d"
    sha256 cellar: :any_skip_relocation, sonoma:         "6d2363865d6ce5d3942bffb99956bfba58dbfafcea757865c8acaa53d037afff"
    sha256 cellar: :any_skip_relocation, ventura:        "78d503347fc3efd302437a233668c009944c7c2b57110b8a0155ad33b2410d4a"
    sha256 cellar: :any_skip_relocation, monterey:       "c039edd32d0d5d7afebbdc7b6947cf32f3e335d58fa7c764925c559b6c27050d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06555eab7fad0248ca318023257da75d745ce84e5d021a9624d9e2f7e18a3245"
  end

  depends_on "asciidoctor" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    outdir = Dir["targetreleasebuildqrtool-*out"].first
    man1.install Dir["#{outdir}*.1"]
  end

  test do
    (testpath"output.png").write shell_output("#{bin}qrtool encode 'QR code'")
    assert_predicate testpath"output.png", :exist?
    assert_equal "QR code", shell_output("#{bin}qrtool decode output.png")
  end
end