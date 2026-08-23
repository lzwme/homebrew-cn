class Katago < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https://katagotraining.org/"
  # Occasionally check upstream docs in case recommended model/network is changed.
  # Ref: https://github.com/lightvector/KataGo?tab=readme-ov-file#other-questions
  url "https://ghfast.top/https://github.com/lightvector/KataGo/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "e6deda07ba926d9813bfcb56eac78f207fc206caff93fbaddc139a1f599d1827"
  license all_of: [
    "MIT",
    "CC0-1.0", # g170 resources
  ]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d3d1de95feed943733df3d9875b1776a181df37818ac9a72881aafa7242df6e1"
    sha256 cellar: :any, arm64_sequoia: "3493f8a86573109fb96b0253b782108479e5e82b5f36e75482f613f9c467999e"
    sha256 cellar: :any, arm64_sonoma:  "055f54e8afc7cae1f6ddf7cf779f2021a2d6cc430e9e827ceed8ac218620396d"
    sha256 cellar: :any, sonoma:        "74774c6b69a3d71ca74c76a03350ca46573a7200eedcde2eb7c657ee56e1c886"
    sha256 cellar: :any, arm64_linux:   "763e64fb06563a376f5569e8bc7ba512542d659b4039f58ed76831c79f90baa7"
    sha256 cellar: :any, x86_64_linux:  "8a6ee8ff0d27f804fb65f28c5e43138e147810fd2cf3a0e6ab81b305c43d1da9"
  end

  depends_on "cmake" => :build
  depends_on "libzip"

  on_macos do
    depends_on "ninja" => :build

    on_arm do
      depends_on "pkgconf" => :build
      depends_on "abseil"
      depends_on "protobuf"
    end

    on_intel do
      depends_on "eigen" => :build
    end
  end

  on_sequoia do
    depends_on xcode: :build # to avoid build getting stuck
  end

  on_linux do
    depends_on "eigen" => :build
    depends_on "zlib-ng-compat"
  end

  # Using most recent b18c384nbt rather than strongest as it is easier to track
  resource "b18c384nbt" do
    url "https://media.katagotraining.org/uploaded/networks/models/kata1/kata1-b18c384nbt-s9996604416-d4316597426.bin.gz", using: :nounzip
    version "s9996604416-d4316597426"
    sha256 "9d7a6afed8ff5b74894727e156f04f0cd36060a24824892008fbb6e0cba51f1d"

    livecheck do
      url "https://katagotraining.org/networks/"
      regex(/href=.*?kata1[._-]b18c384nbt[._-](s\d+[._-]d\d+)\.bin\.gz/i)
    end
  end

  # Following resources are final g170 so shouldn't need to be updated
  resource "20b-network" do
    url "https://ghfast.top/https://github.com/lightvector/KataGo/releases/download/v1.4.5/g170e-b20c256x2-s5303129600-d1228401921.bin.gz", using: :nounzip
    sha256 "7c8a84ed9ee737e9c7e741a08bf242d63db37b648e7f64942f3a8b1b5101e7c2"

    livecheck do
      skip "Final g170 20-block network"
    end
  end

  resource "40b-network" do
    url "https://ghfast.top/https://github.com/lightvector/KataGo/releases/download/v1.4.5/g170-b40c256x2-s5095420928-d1229425124.bin.gz", using: :nounzip
    sha256 "2b3a78981d2b6b5fae1cf8972e01bf3e48d2b291bc5e52ef41c9b65c53d59a71"

    livecheck do
      skip "Final g170 40-block network"
    end
  end

  def install
    # `quick_exit` is absent from the macOS 14 SDK; map it to the equivalent `_Exit`.
    ENV.append_to_cflags "-Dquick_exit=_Exit" if OS.mac? && DevelopmentTools.clang_build_version <= 1600

    args = ["-DNO_GIT_REVISION=1"]
    args += if OS.mac? && Hardware::CPU.arm?
      # Reserve header space for relocation (executable is linked by swiftc).
      ["-DUSE_BACKEND=METAL", "-GNinja", "-DCMAKE_Swift_FLAGS=-Xlinker -headerpad_max_install_names"]
    else
      ["-DUSE_BACKEND=EIGEN", "-DEIGEN3_INCLUDE_DIRS=#{formula_opt_include("eigen")}/eigen3"]
    end

    system "cmake", "-S", "cpp", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/katago"

    pkgshare.install "cpp/configs"
    resources.each { |r| pkgshare.install r }
  end

  test do
    system bin/"katago", "version"
    assert_match(/All tests passed$/, shell_output("#{bin}/katago runtests").strip)
  end
end