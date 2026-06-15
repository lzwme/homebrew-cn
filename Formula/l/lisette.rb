class Lisette < Formula
  desc "Language inspired by Rust that compiles to Go"
  homepage "https://lisette.run"
  url "https://ghfast.top/https://github.com/ivov/lisette/archive/refs/tags/lisette-v0.4.1.tar.gz"
  sha256 "9cf4695bd9ef6e5f9392c43c5ea903c3976435e6561ed71957d1f6bfb40af399"
  license "MIT"
  head "https://github.com/ivov/lisette.git", branch: "main"

  livecheck do
    url :stable
    regex(/^lisette[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9dd3762ac36541761dcb4fcae275c3b6fdf726c74ea6233b9a8cc44f4487d950"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a6d8b8d6cf379c9e5164424d1d82313f8249cd70f0fe34e48973d33c0ebb572"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94c233d5646b9fbdd725c995da82446c7b2f59dce357414ef855023b702467ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "644d169089c4a32982ee83e479f5debe5804f48c2d187687293047f5af7c08ff"
    sha256 cellar: :any,                 arm64_linux:   "7617fdc1064b297c64a30ba89bdd132a31f69149b8156ceca4528dfb80370d9b"
    sha256 cellar: :any,                 x86_64_linux:  "48be47bc89f5f00d87a745eabc7e274bd464fa2501295b90c948a4900b976567"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"lis", "complete", shells: [:bash, :zsh, :fish])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lis version")

    (testpath/"hello.lis").write <<~LIS
      import "go:fmt"

      fn main() {
        fmt.Println("hello")
      }
    LIS
    system bin/"lis", "check", testpath/"hello.lis"
  end
end