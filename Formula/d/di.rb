class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://diskinfo-di.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/diskinfo-di/di-5.0.13.tar.gz"
  sha256 "4c5235f3cfc950fe14b048683c418f044d17395db4372b59485a1c054e1db089"
  license "Zlib"

  # This only matches tarballs in the root directory, as a way of avoiding
  # unstable versions in the `/beta` subdirectory.
  livecheck do
    url :stable
    regex(%r{url=.*?/files/di[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9b07fbfde205d910001a32916b2a9f0f54908b27e35d5bc4d50deef7f500c2e7"
    sha256 cellar: :any,                 arm64_sonoma:  "b9fb083d9a661a09c5a2b9a7f79f660e22babab53cba5f68c47f04a3bfb299a4"
    sha256 cellar: :any,                 arm64_ventura: "b1a3ade82ff8a3a4b0cb2676ccbb68e5dc66b53a5ea16247a39e94c75edfb61f"
    sha256 cellar: :any,                 sonoma:        "23fcff5eed48372d3aed783216ba603a2f7b3241db8907f11b5705e4beddfe06"
    sha256 cellar: :any,                 ventura:       "2e2566e678019c511c4b0a2a53bb9b28a41fa2e4a9034225065fc8148bf46455"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d9bf915684e94382044bdc71411d2062e470d87af4494fc6e02928692ed0a48"
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