class Fourmolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/fourmolu/fourmolu"
  url "https://ghproxy.com/https://github.com/fourmolu/fourmolu/archive/v0.10.1.0.tar.gz"
  sha256 "71adc64cf398cdab3b55310c5d2cdb2e6c5970d63581c28b0c3d8fc49ac45eb7"
  license "BSD-3-Clause"
  head "https://github.com/fourmolu/fourmolu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45ebfa5b2c245b794b4e228e5a0518e8bc2fb39690b977e562b460e625785bea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "622dfe781455e72efbd2e0b08310cfeb91a63a541b5f8ff2dc126cca7bb64b1e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "021666b7a375c7478f0fa6f112b55661243036e5cf286bc12d861e57c0da340f"
    sha256 cellar: :any_skip_relocation, ventura:        "dbf14112d24e53b7bc7ebf9330ede1484d9323d37f5e3a983f52e3dab9fc70b9"
    sha256 cellar: :any_skip_relocation, monterey:       "04c6f18f3afd744ab8bc2eaf5ae97013fa1100818f09082f4b5bec4a2cd1d192"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fcd3f3ba0b2dcb18d8839143d7e59cdfd51d2b6b17eeaac013e1c14e59691bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4eb1f8ea82f1ecaad4240f6b420c3854ca25550e3d24347c0cce61188f04a8d"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"test.hs").write <<~EOS
      foo =
        f1
        p1
        p2 p3

      foo' =
        f2 p1
        p2
        p3

      foo'' =
        f3 p1 p2
        p3
    EOS
    expected = <<~EOS
      foo =
          f1
              p1
              p2
              p3

      foo' =
          f2
              p1
              p2
              p3

      foo'' =
          f3
              p1
              p2
              p3
    EOS
    assert_equal expected, shell_output("#{bin}/fourmolu test.hs")
  end
end