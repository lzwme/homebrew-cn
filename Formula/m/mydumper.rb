class Mydumper < Formula
  desc "MySQL logical backup tool"
  homepage "https://github.com/mydumper/mydumper"
  url "https://ghfast.top/https://github.com/mydumper/mydumper/archive/refs/tags/v1.0.1-3.tar.gz"
  sha256 "d6fcd06d0382c7620359189cb060019291df10bba94bacb279e2df1cebd5953a"
  license "GPL-3.0-or-later"
  head "https://github.com/mydumper/mydumper.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(-\d+)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ed381e58aa4bd80a40d35e1d5570015c2253ee3f590e8130610a5f4c6ab9c06c"
    sha256 cellar: :any,                 arm64_sequoia: "a81408838fae9f8a3597e69b39891608077fa6477b80a047e10d215564681304"
    sha256 cellar: :any,                 arm64_sonoma:  "322a9011ac037bace2d95dfb52664a38431a453c29e163a0797209737551721a"
    sha256 cellar: :any,                 sonoma:        "07b6dc566deffe8f2ea70342370e3a703f26fb572a20c391422a4ceb0bbf58f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "064fcbb4b80e6a8d17bba2b2e41c4fca6a591db8693b7d67727339cc58784897"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edcb404207cb1e73c6ea3a0f385097f44ffe8795b199330de401c7b8755672bf"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "glib"
  depends_on "mariadb-connector-c"
  depends_on "pcre2"

  on_macos do
    depends_on "openssl@3"
  end

  def install
    # Avoid installing config into /etc
    inreplace "CMakeLists.txt", "/etc", etc

    # Override location of mysql-client
    args = %W[
      -DMYSQL_CONFIG_PREFER_PATH=#{Formula["mariadb-connector-c"].opt_bin}
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"mydumper", "--help"
  end
end