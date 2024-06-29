class Clib < Formula
  desc "Package manager for C programming"
  homepage "https:github.comclibsclib"
  url "https:github.comclibsclibarchiverefstags2.8.7.tar.gz"
  sha256 "83d5767e363c3ed4b4271000b9ce63b6e11b6c4740df910e0074f844fb34258e"
  license "MIT"
  head "https:github.comclibsclib.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "adaa04956400da4720ab59df6f5751b1f04e98dd297890f3289eafd55bcd7f3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7209d89f9749907745dffd80fa70d85b722ce4e907020cc55a63dd3d9066e6d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1a9ccc23f7f02055c2df418f3131adea4c9341c0d859d7fe1b84e37d2b82e08"
    sha256 cellar: :any_skip_relocation, sonoma:         "638ea5f7900fa5e5e1fee0f597c2268979333dcf56dc303f2ca8a36d73957bb5"
    sha256 cellar: :any_skip_relocation, ventura:        "6c143f9e0b7d3f78e90b7ddd112ac7c73b5f31500401753e6ebc6ec8d18a6e8a"
    sha256 cellar: :any_skip_relocation, monterey:       "eaaf603e0f7a35bc6ea1f9b51a0704968e608aaee2f587035a37ef108d091faa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b575c125079396fdd1f4fd5b96a0d23048052aa8f0c9ff29986ac5209b14e649"
  end

  uses_from_macos "curl"

  def install
    ENV["PREFIX"] = prefix
    system "make", "install"
  end

  test do
    system "#{bin}clib", "install", "stephenmathiesonrot13.c"
  end
end