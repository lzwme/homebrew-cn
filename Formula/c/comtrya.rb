class Comtrya < Formula
  desc "Configuration and dotfile management tool"
  homepage "https:comtrya.dev"
  url "https:github.comcomtryacomtryaarchiverefstagsv0.9.0.tar.gz"
  sha256 "a5401004a92621057dab164db06ddf3ddb6a65f6cb2c7c4208a689decc404ad4"
  license "MIT"
  head "https:github.comcomtryacomtrya.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "277b41a4edbdb8560e9e848208305443cc65a03d837d5bd30e836ec7c7b862ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f75d9f9221aa7573389d06e57e044155599db6d6f0c66a053b60e98df934725e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "311fa6380c3ad9494d0607f359e6f589d9cf2f2b84f0e882356063112461bf58"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4b1e2c8aee68dddf6cb31d78415a3982c0d237a0f58cca70d21c76450b86c2e"
    sha256 cellar: :any_skip_relocation, ventura:       "8f67df8513e07fa442e6dc51a740954bd4f2c6536b668731a4107aa082f575d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad90d6addf53781eea15f10bfbb08fd0e7c24350bcdf135124b945985093d606"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "app")

    generate_completions_from_executable(bin"comtrya", "gen-completions")
  end

  test do
    assert_match "comtrya #{version}", shell_output("#{bin}comtrya --version")

    resource "testmanifest" do
      url "https:raw.githubusercontent.comcomtryacomtryarefsheadsmainexamplesonlyvariantsmain.yaml"
      sha256 "0715e12cbbb95c8d6c36bb02ae4b49f9fa479e2f28356b8c1f3b5adfb000b93f"
    end

    resource("testmanifest").stage do
      system bin"comtrya", "-d", "main.yaml", "apply"
    end
  end
end