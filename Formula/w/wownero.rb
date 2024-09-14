class Wownero < Formula
  desc "Official wallet and node software for the Wownero cryptocurrency"
  homepage "https:wownero.org"
  # TODO: Check if we can use unversioned `protobuf` at version bump
  url "https:git.wownero.comwownerowownero.git",
      tag:      "v0.11.1.0",
      revision: "1b8475003c065b0387f21323dad8a03b131ae7d1"
  license "BSD-3-Clause"
  revision 5

  # The `strategy` code below can be removed ifwhen this software exceeds
  # version 10.0.0. Until then, it's used to omit a malformed tag that would
  # always be treated as newest.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    strategy :git do |tags, regex|
      malformed_tags = ["10.0.0"].freeze
      tags.map do |tag|
        next if malformed_tags.include?(tag)

        tag[regex, 1]
      end
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "c6350d120c92aa80675a64133daa98ce1de82f536130bf52f0cea6b68dbf1c66"
    sha256 cellar: :any,                 arm64_sonoma:   "17da92001eeaa1c252c3998ec8bf5e36a67a7e024bf7017dc0d7bb2f6f339b9b"
    sha256 cellar: :any,                 arm64_ventura:  "58f6790548e4d11d3345a630988c91136c0e12bcb0fb5cb818d6dbb7a161bafc"
    sha256 cellar: :any,                 arm64_monterey: "3082d89d0fe7b93cf50920f1cdcefd3fd24c930b8de2c6107c9a823fde779e55"
    sha256 cellar: :any,                 sonoma:         "82fb6f7b89fb7e39ac0723ce4555c4439249627966054fd4b95a02d2ebfa4cc3"
    sha256 cellar: :any,                 ventura:        "08418e9fa1c07124a675e867a77f2fec294b45058f8e33fd308ed3573793d2b7"
    sha256 cellar: :any,                 monterey:       "d9c2ea323635f520503e9b8c53db1d599d8c5e192420743470da97c0a918d4f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d08b8e26383ff1a7b709f65214b0f59505ca308f3b675bff55838c91de33a375"
  end

  depends_on "cmake" => :build
  depends_on "miniupnpc" => :build
  depends_on "pkg-config" => :build
  depends_on "boost@1.85"
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
    # Work around build error with Boost 1.85.0.
    # Reported to `monero` where issue needs to be fixed as `wownero` is a fork.
    # Issue ref: https:github.commonero-projectmoneroissues9304
    ENV.append "CXXFLAGS", "-include boostnumericconversionbounds.hpp"
    copy_option_files = %w[
      srccommonboost_serialization_helper.h
      srcp2pnet_peerlist.cpp
      srcwalletwallet2.cpp
    ]
    inreplace copy_option_files, "boost::filesystem::copy_option::overwrite_if_exists",
                                 "boost::filesystem::copy_options::overwrite_existing"
    inreplace "srcsimplewalletsimplewallet.cpp", "boost::filesystem::complete(", "boost::filesystem::absolute("

    # Need to help CMake find `readline` when not using usrlocal prefix
    args = %W[-DReadline_ROOT_DIR=#{Formula["readline"].opt_prefix}]

    # Build a portable binary (don't set -march=native)
    args << "-DARCH=default" if build.bottle?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  service do
    run [opt_bin"wownerod", "--non-interactive"]
  end

  test do
    cmd = "yes '' | #{bin}wownero-wallet-cli --restore-deterministic-wallet " \
          "--password brew-test --restore-height 238084 --generate-new-wallet wallet " \
          "--electrum-seed 'maze vixen spiders luggage vibrate western nugget older " \
          "emails oozed frown isolated ledge business vaults budget " \
          "saucepan faxed aloof down emulate younger jump legion saucepan'" \
          "--command address"
    address = "Wo3YLuTzJLTQjSkyNKPQxQYz5JzR6xi2CTS1PPDJD6nQAZ1ZCk1TDEHHx8CRjHNQ9JDmwCDGhvGF3CZXmmX1sM9a1YhmcQPJM"
    assert_equal address, shell_output(cmd).lines.last.split[1]
  end
end