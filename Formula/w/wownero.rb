class Wownero < Formula
  desc "Official wallet and node software for the Wownero cryptocurrency"
  homepage "https://wownero.org"
  # TODO: Check if we can use unversioned `protobuf` at version bump
  url "https://git.wownero.com/wownero/wownero.git",
      tag:      "v0.11.1.0",
      revision: "1b8475003c065b0387f21323dad8a03b131ae7d1"
  license "BSD-3-Clause"
  revision 1

  # The `strategy` code below can be removed if/when this software exceeds
  # version 10.0.0. Until then, it's used to omit a malformed tag that would
  # always be treated as newest.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :git do |tags, regex|
      malformed_tags = ["10.0.0"].freeze
      tags.map do |tag|
        next if malformed_tags.include?(tag)

        tag[regex, 1]
      end
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "50fc0954f040e8211f7e6d49d20adc99d5f49b58ef68c92d4c9ffd2ec6d6da93"
    sha256 cellar: :any,                 arm64_ventura:  "d869702d01199df642d636f23582f42cb911f884a351304af455e2af0ee68765"
    sha256 cellar: :any,                 arm64_monterey: "a5db5e05bb7075b437aa2eac47468fc5737b9764f4937d3f4b080cbe14da7557"
    sha256 cellar: :any,                 sonoma:         "1163887e1cc4ed1bb20a77c3fae327333d53aa5f40bcccd320cb18c9f3fac41d"
    sha256 cellar: :any,                 ventura:        "08a35b3578d565c876f8cd681b822d46c02c95ee53c78d6727357a1c6eca09ad"
    sha256 cellar: :any,                 monterey:       "f3fac7f2aa73fa0762610b3cfbd6d956f58fa2df74dec20b391178ad1aa72736"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43c7eb13bf159db6061aa2230b36bf74415b6e65ece15dd5a01651c96c0fcf81"
  end

  depends_on "cmake" => :build
  depends_on "miniupnpc" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "hidapi"
  depends_on "libsodium"
  depends_on "libusb"
  depends_on "openssl@3"
  depends_on "protobuf@21"
  depends_on "readline"
  depends_on "unbound"
  depends_on "zeromq"

  conflicts_with "monero", because: "both install a wallet2_api.h header"

  def install
    # Need to help CMake find `readline` when not using /usr/local prefix
    args = %W[-DReadline_ROOT_DIR=#{Formula["readline"].opt_prefix}]

    # Build a portable binary (don't set -march=native)
    args << "-DARCH=default" if build.bottle?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  service do
    run [opt_bin/"wownerod", "--non-interactive"]
  end

  test do
    cmd = "yes '' | #{bin}/wownero-wallet-cli --restore-deterministic-wallet " \
          "--password brew-test --restore-height 238084 --generate-new-wallet wallet " \
          "--electrum-seed 'maze vixen spiders luggage vibrate western nugget older " \
          "emails oozed frown isolated ledge business vaults budget " \
          "saucepan faxed aloof down emulate younger jump legion saucepan'" \
          "--command address"
    address = "Wo3YLuTzJLTQjSkyNKPQxQYz5JzR6xi2CTS1PPDJD6nQAZ1ZCk1TDEHHx8CRjHNQ9JDmwCDGhvGF3CZXmmX1sM9a1YhmcQPJM"
    assert_equal address, shell_output(cmd).lines.last.split[1]
  end
end