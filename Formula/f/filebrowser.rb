class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://ghfast.top/https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.63.17.tar.gz"
  sha256 "3869a813ca9fffcfc3cadb515f4f50f37ffd90a7c1f0a1199526407ce8515723"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f91aec0dced70c10f2fad517c60c8ab841281dcdb697730a0bd22a88448e7b7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdec5adb7ed1885ca921896e5b12c61c44d833a8ec94600f53da2a72a1214632"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "105ed38db046006b84eaba4ef1b6f17e05457eadb45f1b95bc98240de8b07d1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "97bb72415b24c9377b2cf05602721669bd568502bc22bfc29a0fc4cb1111bb64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d04a97a633f3a6c3f4df23de44f7c35d31e8c3bcaba0811db60466a929844cc5"
    sha256 cellar: :any,                 x86_64_linux:  "944884a315f5c17f8ad9e6ce0e8f840ff207618c7c4f937d3b090e380ed68028"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/filebrowser/filebrowser/v2/version.Version=#{version}
      -X github.com/filebrowser/filebrowser/v2/version.CommitSHA=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"filebrowser", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/filebrowser version")

    system bin/"filebrowser", "config", "init"
    assert_path_exists testpath/"filebrowser.db"

    output = shell_output("#{bin}/filebrowser config cat 2>&1")
    assert_match "Using database: #{testpath}/filebrowser.db", output
  end
end