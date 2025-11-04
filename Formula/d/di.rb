class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://diskinfo-di.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/diskinfo-di/di-6.1.0.tar.gz"
  sha256 "4cdd0944db0a9566f55fab375de605778b91fc91daef8005cc0dbfaac61f6af0"
  license "Zlib"

  # This only matches tarballs in the root directory, as a way of avoiding
  # unstable versions in the `/beta` subdirectory.
  livecheck do
    url :stable
    regex(%r{url=.*?/files/di[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "74973f3338535718524bb650f23595d7cc2f1b3261dd3d8b4ba090c9b2f112ed"
    sha256 cellar: :any,                 arm64_sequoia: "1c5757cd0c978d2f2783f1b92d55dbf8a66ef64860ea592e17724aa767e9ae46"
    sha256 cellar: :any,                 arm64_sonoma:  "33ecedca25f701f96b99992b9abfce95ab8e4b90e3e59fd300b17fa39de021a1"
    sha256 cellar: :any,                 sonoma:        "522b31d94a39281176a5a44303b5750775b4ed799de941ea3ae79dc1e090c218"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ba23e3ba54df50f5bb15d17db495d6172471718ece4d995fa38bf3fd50abac3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95b733e984672a9867af49f4cdc4b1845221ffde9d06a86eb1a6b4db972fec8f"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  def install
    args = %W[
      -DDI_BUILD=Release
      -DDI_VERSION=#{version}
      -DDI_LIBVERSION=#{version}
      -DDI_SOVERSION=#{version.major}
      -DDI_RELEASE_STATUS=production
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/di --version")
    system bin/"di"
  end
end