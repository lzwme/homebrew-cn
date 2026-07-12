class SymfonyCli < Formula
  desc "Build, run, and manage Symfony applications"
  homepage "https://symfony.com/download"
  url "https://ghfast.top/https://github.com/symfony-cli/symfony-cli/archive/refs/tags/v5.18.0.tar.gz"
  sha256 "541ae56fe0b0883147cb44f5cb8bdc6a79bfa845d5510f08f393c54afa4a8096"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "faa688bdeda516a8472553edaeed5793666552c283fdfa3d99f254aa6713f4f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21e28afaea2f8fceb5f01b8314daaccbdb1ec7c73a9c2faa5c92992e555d4c36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b2000f0ad5d0c5dfd1ca5664efeaf7ae833e70788ec152f869904d5c417f6b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "7266b052d3db829fcd76f2ffe226861c6bcb6c4b51be9daca71b5347c6db1113"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14240a2c1b7c5e0e79c04cdfdcf3dea9415fae961640765bf678969bf0dcd3f8"
    sha256 cellar: :any,                 x86_64_linux:  "2f6d51127e91b0f25234a796882195b754adb3f838ef06f9bddf4dbd0dbad88c"
  end

  depends_on "go" => :build
  depends_on "composer" => :test

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.buildDate=#{time.iso8601}
      -X main.channel=stable
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"symfony")

    generate_completions_from_executable(bin/"symfony", "self:completion")
  end

  service do
    run ["#{opt_bin}/symfony", "local:proxy:start", "--foreground"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/symfony self:version")

    system bin/"symfony", "new", "--no-git", testpath/"my_project"
    assert_path_exists testpath/"my_project/symfony.lock"
  end
end