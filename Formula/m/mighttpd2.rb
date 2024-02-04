class Mighttpd2 < Formula
  desc "HTTP server"
  # raised a homepage issue https:github.comkazu-yamamotomighttpd2issues28
  homepage "https:github.comkazu-yamamotomighttpd2"
  url "https:hackage.haskell.orgpackagemighttpd2-4.0.4mighttpd2-4.0.4.tar.gz"
  sha256 "a21ac95098c6dca6902dbf6131614dd6296f819a96c82dee875ec48a0c2cefe2"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d9e260284e27ed041fbf78223a97b8c7804989876dc4709ef2b742ae07d251ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a547703388b9a8620a99f3f8542beaa5b015a7c657b4f1860e9c583cd7e7ad0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "155940971008fb0dbf9f392c85fd3583a53f2809c995b6fadc8b294e8f3ea3d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf3bb850495b707a2f4dfed398f62eb110e6ae452e664ce0ed1215b326641228"
    sha256 cellar: :any_skip_relocation, ventura:        "49245485f7198ac3e9997c3204916fa8b781625d53e59574edd3a2bfbd9a8f7e"
    sha256 cellar: :any_skip_relocation, monterey:       "baecdfd2b85bc1b9c55386fa5723f040fa93d9e15d92b9da574e686a47451449"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bb3ab5e76139985f3cbd9995c2fc0b9cdc86ad6c2238e258e8523b8b88c2058"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", "-ftls", *std_cabal_v2_args
  end

  test do
    system "#{bin}mighty-mkindex"
    assert (testpath"index.html").file?
  end
end