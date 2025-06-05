class Katago < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "https:github.comlightvectorKataGo"
  # Occasionally check upstream docs in case recommended modelnetwork is changed.
  # Ref: https:github.comlightvectorKataGo?tab=readme-ov-file#other-questions
  url "https:github.comlightvectorKataGoarchiverefstagsv1.16.2.tar.gz"
  sha256 "1f8234413aeb01f45a1c03652d07160e571b9112735e5478f8b6e072e9009bb7"
  license all_of: [
    "MIT",
    "CC0-1.0", # g170 resources
  ]

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "46507964a2e3a03974f3eb75293c11646b4cda6102a65afd87e97adc55fd2173"
    sha256 cellar: :any,                 arm64_sonoma:  "3142c70bfc9359d33c95180d764175ff33901f6a15eb742b10cdd48aa54994e8"
    sha256 cellar: :any,                 arm64_ventura: "f74deaf28ea89664ef4a93ee876b7d1354a18ba05d42263ba9caeaf1a63fd7a4"
    sha256 cellar: :any,                 sonoma:        "8e7f2fb2d0ebbb61cad0784aab893c9ee1da60a887518502f641d7c191985292"
    sha256 cellar: :any,                 ventura:       "207fd5d9c4b0d90ebe9f468f18211b91d690e4a8ad1aa72101c2c9ec3c2ffbc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23b16da526d08426a9110990305da062799a79219cbe91244381fd4ed571f68f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "559f97780089d7862bb2a514a6e3e82c5841df38530e81f2fdc07ecde25b0845"
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