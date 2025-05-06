class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https:k6.io"
  url "https:github.comgrafanak6archiverefstagsv0.59.0.tar.gz"
  sha256 "a2c5ed79dd93d19b97df3a377883245883b3ec86869ec1309b3f090d4d402942"
  license "AGPL-3.0-or-later"
  head "https:github.comgrafanak6.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "995d62c03ac9a167a8bdc4a2e50bc785f8465223776d66e068c7071d8a7515be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "995d62c03ac9a167a8bdc4a2e50bc785f8465223776d66e068c7071d8a7515be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "995d62c03ac9a167a8bdc4a2e50bc785f8465223776d66e068c7071d8a7515be"
    sha256 cellar: :any_skip_relocation, sonoma:        "44bb4d7152b3e5ce2d77515cde59ecc693979a9c9dac41a7479b8d07a4774bc0"
    sha256 cellar: :any_skip_relocation, ventura:       "44bb4d7152b3e5ce2d77515cde59ecc693979a9c9dac41a7479b8d07a4774bc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "353917b8a8fa1a2a38549cbbf37e1bab712139f5b3572f3d75ee82733f62addf"
  end

  depends_on "go" => :build

  def install
    # see comment, https:github.comHomebrewhomebrew-corepull217383#issuecomment-2766058674
    odie "Revert the version check for 0.58.0" if build.stable? && version > "0.59.0"

    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"k6", "completion")
  end

  test do
    (testpath"whatever.js").write <<~JS
      export default function() {
        console.log("whatever");
      }
    JS

    assert_match "whatever", shell_output("#{bin}k6 run whatever.js 2>&1")

    system bin"k6", "version"
  end
end