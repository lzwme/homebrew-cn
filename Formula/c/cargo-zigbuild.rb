class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https:github.comrust-crosscargo-zigbuild"
  url "https:github.comrust-crosscargo-zigbuildarchiverefstagsv0.19.2.tar.gz"
  sha256 "0173b159f8c18d860bf1e61b1276e88f0251050f1ebbbc7170110febe9f115b3"
  license "MIT"
  head "https:github.comrust-crosscargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "64a19784cdc342d95ff8d7ea27d8916434ad34fdbcd28499ee152b112ae4baab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8d4b93c2be1869fc7c4b8a787b02882341fe3b267546dbc5e08de0aacc8ceec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7d93da76680d7a87feadedd1dfe616b5701192c2287f9ad70b8b509dcdbe261f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8799ca0702142f9e342e256d79b712e43b1cea29a763438322c17c1ad4d5b74f"
    sha256 cellar: :any_skip_relocation, ventura:       "74b6569b437c48901c58bf186533f3585b5c1f9d0239a74779e1ee2f0a5d242d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e32a3f7a0b8d45ca445444f7fc00bdaff634c9c3cd44bebee98fd072724f490d"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test
  depends_on "zig"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Remove errant CPATH environment variable for `cargo zigbuild` test
    # https:github.comziglangzigissues10377
    ENV.delete "CPATH"
    ENV.delete "RUSTFLAGS"

    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"
    system "rustup", "target", "add", "aarch64-unknown-linux-gnu"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      system "cargo", "zigbuild", "--target", "aarch64-unknown-linux-gnu"
    end
  end
end