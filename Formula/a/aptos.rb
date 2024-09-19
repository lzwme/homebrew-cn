class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https:aptosfoundation.org"
  url "https:github.comaptos-labsaptos-corearchiverefstagsaptos-cli-v4.2.0.tar.gz"
  sha256 "75a6b025af0489f42b4521523ad56b79e257346c58ba5e65626c1e268e8363c1"
  license "Apache-2.0"
  head "https:github.comaptos-labsaptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(^aptos-cli[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c638c60499bce76d566b1ef14c6bb8fc728b4ac3de6dad19113a26ee34ced145"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c61dcfa0dc3137fdbab7525b18ea371e8245122e0feee76f72e1e8db2b44e612"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "85bf910ec282cbff917ad01022a19961b685b150580582c5a72a5b2c291f247b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a56b984afa6fbc001f3d215f73be8ea7ce4c646f4430ab2992e2cfd911b2cfc9"
    sha256 cellar: :any_skip_relocation, ventura:       "4ca5053fee26e164931472bf66042cae8425e9e3513c827867338e56e028060a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e361ba3a0000316e72e2387c578db4bbe334b581e6ea8fa4793c5ba8c524a46"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "rustfmt" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkg-config" => :build
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
    # FIXME: Figure out why cargo doesn't respect .cargoconfig.toml's rustflags
    ENV["RUSTFLAGS"] = "--cfg tokio_unstable -C force-frame-pointers=yes -C force-unwind-tables=yes"
    system "cargo", "install", *std_cargo_args(path: "cratesaptos"), "--profile=cli"
  end

  test do
    assert_match(output.pubi, shell_output("#{bin}aptos key generate --output-file output"))
  end
end