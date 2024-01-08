class BulkExtractor < Formula
  desc "Stream-based forensics tool"
  homepage "https:github.comsimsongbulk_extractorwiki"
  url "https:github.comsimsongbulk_extractorreleasesdownloadv2.0.6bulk_extractor-2.0.6.tar.gz"
  sha256 "ab2640c522339fce8ab99541c090e272b16430760828b567229c89d4c1b469ad"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3ce2def44987f5e359e7d17550d9509dcb631e69cd867e8e74ce99056861042b"
    sha256 cellar: :any,                 arm64_ventura:  "02b11f38e7c0165644317b9e528a9a5b80a924e9e5aabe6b692d39d6dd15632d"
    sha256 cellar: :any,                 arm64_monterey: "b7a14791ead02e6c39ff7958de0155b9e4eef59a45e7c6e2b16fd39637938c36"
    sha256 cellar: :any,                 sonoma:         "218a19007c3b2b0ccf4f7a35054193e371b8265feed351114e6cc02105c4801b"
    sha256 cellar: :any,                 ventura:        "7c403db710c3c5887f2c25e45a1c44ae06b8ce90dc946c941a942b4a977d6b94"
    sha256 cellar: :any,                 monterey:       "c95ec4db52f32a0769315d7063e39aaea9b490c25241bb1e9c05f126a2790a84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7950babdad484251579996ccd40bcb4526608c618aa4ae835d01fd8a05d20fc"
  end

  head do
    url "https:github.comsimsongbulk_extractor.git", branch: "main"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openssl@3"

  uses_from_macos "flex" => :build
  uses_from_macos "expat"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system ".bootstrap.sh" if build.head?
    # Disable RAR to avoid problematic UnRAR license
    system ".configure", *std_configure_args, "--disable-rar", "--disable-silent-rules"
    system "make"
    system "make", "install"

    # Install documentation
    (pkgshare"doc").install Dir["doc*.{html,txt,pdf}"]

    (lib"python2.7site-packages").install Dir["python*.py"]
  end

  test do
    input_file = testpath"data.txt"
    input_file.write "https:brew.sh\n(201)555-1212\n"

    output_dir = testpath"output"
    system bin"bulk_extractor", "-o", output_dir, input_file

    assert_match "https:brew.sh", (output_dir"url.txt").read
    assert_match "(201)555-1212", (output_dir"telephone.txt").read
  end
end