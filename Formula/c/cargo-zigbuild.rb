class CargoZigbuild < Formula
  desc "Compile Cargo project with zig as linker"
  homepage "https:github.comrust-crosscargo-zigbuild"
  url "https:github.comrust-crosscargo-zigbuildarchiverefstagsv0.19.5.tar.gz"
  sha256 "19d728732fe9ddc11acb2c203abea79ea6bd7bfb826f90c190a96f99e82b92a6"
  license "MIT"
  head "https:github.comrust-crosscargo-zigbuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fe8aedf2d2f4a51ab41192d07d01317e6322afca87b3923d1e2dbcfed6a54f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eda648ad049668e45ef27f7966ca3b59115bead0db8961ee65c181fcfc164dde"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cb41c6b633ad0a923dbfa1305d45451447affcb92d00e04b60eacb07dd7460a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5ea4b846f7235ec2d39932c49e00a03d30cdfbeea63d1cf24bfd9b253ae2ab0"
    sha256 cellar: :any_skip_relocation, ventura:       "6acce09585caaba7329618f1aececc5e9f2dfe16b5b369000623da81aa29c6aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8f4ee158906249313b6cefcbdb9e39725ff47761bd2cb56098e3af48d597a57"
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