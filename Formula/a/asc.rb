class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/2.2.0.tar.gz"
  sha256 "a3635c1181a3497a590ca0cfb43d4d046a305a26ba70fc2b0940196c7ec806e7"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57b65e026eb0f6a691a02bd3467d65f5cc6f05c364395555047ce1ebb2b7f7f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19059c7aa8e107e89d5dd09f0f756caa98d79a7812de543c98190f6ae2159de7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7780740316b3f804eb9dccce6681577019af7b3a9a950495a7f68681a1e3b5be"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd2fb18185e2d76710a9e4a26449a4d5e9415d481d4b93dff68ce65b1a739fba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16fe902babc65690884f780919bb606defe5f0d356d800ef87da9ffe58b3d4d0"
    sha256 cellar: :any,                 x86_64_linux:  "1c1d96fb4df11184926db28d1c4573ba0ebff79ba4c829d7e9da9f4d44c3a4ad"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end