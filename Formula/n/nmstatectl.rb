class Nmstatectl < Formula
  desc "Command-line tool that manages host networking settings in a declarative manner"
  homepage "https://nmstate.io/"
  url "https://ghfast.top/https://github.com/nmstate/nmstate/releases/download/v2.2.51/nmstate-2.2.51.tar.gz"
  sha256 "000776e5b51757b27339466384024b7a1330c81bcbafd926992f087d9fdcf22f"
  license "Apache-2.0"
  head "https://github.com/nmstate/nmstate.git", branch: "base"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7546fa2b8a3fbb82dc627c3b0f9be1c5c24bb931c14b7f4a3c393e17c9b1524f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6264e7c73e3fb28c8516d6d91542f9adb6f633a9ef8dbbb372e9413c4f4ea2dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "382a318589659f7463531a0880b1acb0c59c54338a8840d77291688f91c8c400"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1b133936ab45d03080bcf824e1f8a758fabda675fcaf9a3c4053e2e1f262fce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "224d54b3e992ac77902b8698f07ae7fdeea0497c9064207b6f65906465476792"
  end

  depends_on "rust" => :build

  def install
    cd "rust" do
      args = if OS.mac?
        ["--no-default-features", "--features", "gen_conf"]
      else
        []
      end
      system "cargo", "install", *args, *std_cargo_args(path: "src/cli")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nmstatectl --version")

    assert_match "interfaces: []", pipe_output("#{bin}/nmstatectl format", "{}", 0)
  end
end