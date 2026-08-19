class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://ghfast.top/https://github.com/kovetskiy/mark/archive/refs/tags/v16.12.0.tar.gz"
  sha256 "473b21a29017c1f10a93b2dae64c8d715630736133fef9119290c6497d63ad77"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1aa3f8f3b1cb896a135bc5c6f7ac596c689c65d8094e6f3be2a3430632be7fc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1aa3f8f3b1cb896a135bc5c6f7ac596c689c65d8094e6f3be2a3430632be7fc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1aa3f8f3b1cb896a135bc5c6f7ac596c689c65d8094e6f3be2a3430632be7fc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf37eb4c487daee3602a69df8925abfece45e3713d74fa4c555b3766bfb37c0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55a53c238902d610dace47a682ffd3cc61a39aa6424d6afde8ec3d55d1aea497"
    sha256 cellar: :any,                 x86_64_linux:  "bedaee54339e34660dc1ed123d66d330994328cc64ee468f11ce5a661de455bd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/mark"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mark --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello Homebrew
    MARKDOWN

    touch testpath/"mark.toml"
    output = shell_output("#{bin}/mark --config mark.toml sync 2>&1", 1)
    assert_match "confluence password should be specified", output
  end
end