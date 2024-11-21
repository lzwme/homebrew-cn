class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https:aptosfoundation.org"
  url "https:github.comaptos-labsaptos-corearchiverefstagsaptos-cli-v4.5.0.tar.gz"
  sha256 "8041cd82b726df476a61c5ddd666a93d0143a0904df094689157754b591d7dcf"
  license "Apache-2.0"
  head "https:github.comaptos-labsaptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(^aptos-cli[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c4177dffeacfc22010419c77a036dd6759eb714536d9eaa2051cb2a80e3e847"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42f31d2fab55bd23562213c11280381698b92ba43e091e6113f49ee7a066933d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "92a7fd437e56293c07d1358dd73ad6a3c4153bbc94dc4a0dc72565a136149636"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4d05e0e3a6d5deb0f48e38607c590c903442bed3ffa88f5dca76348dfded110"
    sha256 cellar: :any_skip_relocation, ventura:       "169af69232df99b3b95a5205eb657dccd78d422c94bca948b37a0646e609d319"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed5d4614eef5e39abcf7b1d83cf174718d51365ed5ff6951f158c7b257d54472"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "zip" => :build
    depends_on "openssl@3"
    depends_on "systemd"
  end

  # rust 1.80.0 build patch, upstream pr ref, https:github.comaptos-labsaptos-corepull14272
  patch do
    url "https:github.comaptos-labsaptos-corecommit72b9657316c699cfbef75216f578a0bd99e0be46.patch?full_index=1"
    sha256 "f93b4f8b0a61d245e13d6776834cec9ecdd3b0103d53b43dcc79cda3e3f787ed"
  end

  def install
    # FIXME: Look into a different way to specify extra RUSTFLAGS in superenv as they override .cargoconfig.toml
    # Ref: https:github.comHomebrewbrewblobmasterLibraryHomebrewextendENVsuper.rb#L65
    ENV.append "RUSTFLAGS", "--cfg tokio_unstable -C force-frame-pointers=yes -C force-unwind-tables=yes"
    system "cargo", "install", *std_cargo_args(path: "cratesaptos"), "--profile=cli"
  end

  test do
    assert_match(output.pubi, shell_output("#{bin}aptos key generate --output-file output"))
  end
end