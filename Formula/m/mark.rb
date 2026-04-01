class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://github.com/kovetskiy/mark"
  url "https://ghfast.top/https://github.com/kovetskiy/mark/archive/refs/tags/v16.2.0.tar.gz"
  sha256 "c32681bbf87a6da063c10771ba10133357010d7e6d91aa44046b3745c7bb8c55"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "018b865740d909ff1c27ab4fb7f0bf68b4bd1c1077468ec5a198178daaa93c70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "018b865740d909ff1c27ab4fb7f0bf68b4bd1c1077468ec5a198178daaa93c70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "018b865740d909ff1c27ab4fb7f0bf68b4bd1c1077468ec5a198178daaa93c70"
    sha256 cellar: :any_skip_relocation, sonoma:        "bac2a083a79746295f61f79bdcbfda815e65567a9ceb15635a330256119edad6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e3fc697ddafaa0de19bc24528893425d4469c0d0181592ede2eea5349a116db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a3bb60fbeefa0dd4a09395c4423e5e5c6dc75d830c9ae3b3aea4fd084b5c5cf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/mark"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mark --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello Homebrew
    MARKDOWN

    output = shell_output("#{bin}/mark --config nonexistent.yaml sync 2>&1", 1)
    assert_match "confluence password should be specified", output
  end
end