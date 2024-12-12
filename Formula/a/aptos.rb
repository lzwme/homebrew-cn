class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https:aptosfoundation.org"
  url "https:github.comaptos-labsaptos-corearchiverefstagsaptos-cli-v5.0.0.tar.gz"
  sha256 "e2afd670d2e9d39622b9da4acd40f05bb5173fc36c61de711ec58bcdaed4062a"
  license "Apache-2.0"
  head "https:github.comaptos-labsaptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(^aptos-cli[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2824da89278d797be5653423ac32dfb34a83df31bc88dfcac7c6829619a86a30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8562a11b698e93d868c1c0805444e1ab1ab40b288df8a36a302d76254be6ac3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d61a9cb0c4252e161781d2261e587d2072ecb61319182284d29b98d52c0129f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b89696cac8ad2d06a1581f1bc1710e2a3a3a44581fc5618ea61de0df03bf523"
    sha256 cellar: :any_skip_relocation, ventura:       "301c22509fbd7977e7ba63562846df4c0c9c74f3d9558183784a563bfbb31734"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e69fa057e54bdb21e73ad47d998add7f599622e5f535c59b87489884d8b2255c"
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