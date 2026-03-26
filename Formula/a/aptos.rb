class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://ghfast.top/https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v9.1.0.tar.gz"
  sha256 "940db44e50d90386af61ba00495dc7329f6aafa3f5168473c65472c85a3e3c1b"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f001d517b9296cf5612b805effdcb2ce9a51bc75fc297d70808babd5861e30c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bce37f656e96afd28de4fdbf21ddc156c5db395866d5124ab7a77902eb621db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c553b9dabd105bb3d6f64be90c37504ed8e4c9d79f274588e79ace842609cb44"
    sha256 cellar: :any_skip_relocation, sonoma:        "14d84766dd23760095a5d66d806184a5e4248ce884416256ddc656d68d35b7ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7d3b7240a67c52fc1d0fdcd7139192396666604146d9916c7f9633979c76b98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7d55faac0071adedc40c6f23ffc0613db4148f6dd9fa71ef2720d5cfaf4eda0"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "zip" => :build
    depends_on "elfutils"
    depends_on "openssl@3"
    depends_on "systemd"

    on_intel do
      depends_on "lld" => :build
    end
  end

  def install
    # Remove optimization to allow bottles to be run on our minimum supported CPUs
    inreplace ".cargo/config.toml", /,\s*"-C",\s*"target-cpu=x86-64-v3"/, ""

    system "cargo", "install", *std_cargo_args(path: "crates/aptos"), "--profile=cli"
  end

  test do
    assert_match(/output.pub/i, shell_output("#{bin}/aptos key generate --output-file output"))
  end
end