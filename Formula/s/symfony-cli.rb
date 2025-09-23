class SymfonyCli < Formula
  desc "Build, run, and manage Symfony applications"
  homepage "https://github.com/symfony-cli/symfony-cli"
  url "https://ghfast.top/https://github.com/symfony-cli/symfony-cli/archive/refs/tags/v5.14.1.tar.gz"
  sha256 "e031b89312d0ea75ccf17b39ae4b50777772f290e9a4f9c54e8a0cb457e074d9"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3484b9a63b2f2f146fa216385d3511b3ca7420b9b1972eb5a1fc62a4f861bc92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb09540122c2a3315cfee90e21cf09100077d20990df188123dbb2d706cfaf1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa80317318ddff20410c507bc09866a40642f43a215d585e6cbb744da46ac68f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e37384e3e435b604e6f84508c3d37c93bac8f89265abafbe10acb8cb9429efe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20c20217ebf05147fc81bdac02bea5b11b10bae782311ae83677cd5901af33b3"
  end

  depends_on "go" => :build
  depends_on "composer" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.channel=stable", output: bin/"symfony")
  end

  test do
    system bin/"symfony", "new", "--no-git", testpath/"my_project"
    assert_path_exists testpath/"my_project/symfony.lock"
    output = shell_output("#{bin}/symfony -V")
    assert_match version.to_s, output
    assert_match "stable", output
  end
end