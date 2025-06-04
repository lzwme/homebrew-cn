class Katago < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https:github.comlightvectorKataGo"
  # Occasionally check upstream docs in case recommended modelnetwork is changed.
  # Ref: https:github.comlightvectorKataGo?tab=readme-ov-file#other-questions
  url "https:github.comlightvectorKataGoarchiverefstagsv1.16.1.tar.gz"
  sha256 "5e004042dc1ee8185b8fb7a807e3d421d09349dccb858e41ffe2e9b96a4173d0"
  license all_of: [
    "MIT",
    "CC0-1.0", # g170 resources
  ]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "196387b2b8364d6c21b3ad7f21e99ce5a9a0de12ea8bd1b13df64267a9247808"
    sha256 cellar: :any,                 arm64_sonoma:  "f18c1f3a208bc7db520b128de3f554c22a3f06e2f3b7359c2a7399ef4ad6015c"
    sha256 cellar: :any,                 arm64_ventura: "721c9102dac3e2e115a05cfcc87ad46d3e4ed8b1b2a4e97c0fc27768fb0efcd4"
    sha256 cellar: :any,                 sonoma:        "8a11310fbdc2db3bd226f99266b7f4440a2d8ecefa68a2ec64306a1f72bd167e"
    sha256 cellar: :any,                 ventura:       "a756163f9bc8424595dd5e2bf03eb9243b03749bbbdd58c31b9e471337a3c9ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3617c29c7f43a9224c99d3d3a649d5427be69fb9c152b0f2c5dd456979b9278d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a6a7e66ecb9f2c5972fb8836157bb3b11285efca806d314f75b59840643f0a5"
  end

  depends_on "cmake" => :build
  depends_on "libzip"
  depends_on macos: :mojave

  uses_from_macos "zlib"

  on_macos do
    depends_on "ninja" => :build
  end

  on_linux do
    depends_on "eigen" => :build
  end

  # Using most recent b18c384nbt rather than strongest as it is easier to track
  resource "b18c384nbt" do
    url "https:media.katagotraining.orguploadednetworksmodelskata1kata1-b18c384nbt-s9996604416-d4316597426.bin.gz", using: :nounzip
    version "s9996604416-d4316597426"
    sha256 "9d7a6afed8ff5b74894727e156f04f0cd36060a24824892008fbb6e0cba51f1d"

    livecheck do
      url "https:katagotraining.orgnetworks"
      regex(href=.*?kata1[._-]b18c384nbt[._-](s\d+[._-]d\d+)\.bin\.gzi)
    end
  end

  # Following resources are final g170 so shouldn't need to be updated
  resource "20b-network" do
    url "https:github.comlightvectorKataGoreleasesdownloadv1.4.5g170e-b20c256x2-s5303129600-d1228401921.bin.gz", using: :nounzip
    sha256 "7c8a84ed9ee737e9c7e741a08bf242d63db37b648e7f64942f3a8b1b5101e7c2"

    livecheck do
      skip "Final g170 20-block network"
    end
  end

  resource "40b-network" do
    url "https:github.comlightvectorKataGoreleasesdownloadv1.4.5g170-b40c256x2-s5095420928-d1229425124.bin.gz", using: :nounzip
    sha256 "2b3a78981d2b6b5fae1cf8972e01bf3e48d2b291bc5e52ef41c9b65c53d59a71"

    livecheck do
      skip "Final g170 40-block network"
    end
  end

  def install
    args = ["-DNO_GIT_REVISION=1"]
    args += if OS.mac?
      ["-DUSE_BACKEND=METAL", "-GNinja"]
    else
      ["-DUSE_BACKEND=EIGEN"]
    end

    system "cmake", "-S", "cpp", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "buildkatago"

    pkgshare.install "cppconfigs"
    resources.each { |r| pkgshare.install r }
  end

  test do
    system bin"katago", "version"
    assert_match(All tests passed$, shell_output("#{bin}katago runtests").strip)
  end
end