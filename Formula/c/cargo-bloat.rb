class CargoBloat < Formula
  desc "Find out what takes most of the space in your executable"
  homepage "https:github.comRazrFalconcargo-bloat"
  url "https:github.comRazrFalconcargo-bloatarchiverefstagsv0.12.1.tar.gz"
  sha256 "8195cebb94a740cd3b89611ae79d7d3e2d8fd8ec297f5a0f07efa7069ef05be7"
  license "MIT"
  head "https:github.comRazrFalconcargo-bloat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b9caa51f467a8ff4272b885a45091bd018e2defd629aa70d1a58686553ea9545"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e785499e4d1ca0ea95076b21ec4f73098c5a2e7af38f9cd804465786f1745a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6cb18085aca63f0c6730d86532d74276a598d5587f7bd4cf64f6352593bb16b"
    sha256 cellar: :any_skip_relocation, sonoma:         "f643448f04a72a456a13efb160fe1470144128d55c7e3d7f44fe8c6a1027ec2b"
    sha256 cellar: :any_skip_relocation, ventura:        "d0de5a94dec7e213075d86b9bb4ac9c206c7308fcf34b75388477ca58825e189"
    sha256 cellar: :any_skip_relocation, monterey:       "a374eabb4b4da3740c97abcf9e2f4a030a21d3ac6c3ff503269d4a153086a00a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c271533c6e4ff7415d51ccb2fcbee8e514e0ec2142a48543a5c8dd705ac9e4a"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https:github.comHomebrewhomebrew-corepull134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      output = shell_output("#{bin}cargo-bloat --release -n 10 2>&1", 1)
      assert_match "Error: can be run only via `cargo bloat`", output
      output = shell_output("cargo bloat --release -n 10 2>&1")
      assert_match "Analyzing targetreleasehello_world", output
    end
  end
end