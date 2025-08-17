class Xcdiff < Formula
  desc "Tool to diff xcodeproj files"
  homepage "https://github.com/bloomberg/xcdiff"
  url "https://github.com/bloomberg/xcdiff.git",
      tag:      "0.13.0",
      revision: "99301ee4578224f0660a1312abc465c5a37176c5"
  license "Apache-2.0"
  head "https://github.com/bloomberg/xcdiff.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6af8cba695e556e3d1486f1ee108d647d9ff45c69dbe63e66c683830ba8edb34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70995592131e0eb7cb495e7b45b0398c2b7e0d37c6ae3b44e30fce1b7151961b"
    sha256 cellar: :any,                 arm64_ventura: "04a679bb1c3d2e6125594ca56e4c34f48d6d2e7425d15955fbc1d52a8ba916ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "5520630a6cac7c1e170824dd6fc509beaa446ec8163780ce7f02ca6b49ceb228"
    sha256 cellar: :any,                 ventura:       "2a302b05ff15c6ffd959cbd6b7306d6a09c76b0318d2902b2f952c9d88cbb870"
  end

  depends_on :macos

  uses_from_macos "swift" => :build, since: :sonoma # swift 5.10+

  def install
    system "make", "update_version"
    system "make", "update_hash"
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/xcdiff"
    generate_completions_from_executable(bin/"xcdiff", "--generate-completion-script")
  end

  test do
    resource "homebrew-testdata" do
      url "https://ghfast.top/https://github.com/bloomberg/xcdiff/archive/refs/tags/0.10.0.tar.gz"
      sha256 "c093e128873f1bb2605b14bf9100c5ad7855be17b14f2cad36668153110b1265"
    end

    assert_match version.to_s, shell_output("#{bin}/xcdiff --version").chomp
    project = "Fixtures/ios_project_1/Project.xcodeproj"
    diff_args = "-p1 #{project} -p2 #{project}"
    resource("homebrew-testdata").stage do
      # assert no difference between projects
      assert_equal "\n", shell_output("#{bin}/xcdiff #{diff_args} -d")
      out = shell_output("#{bin}/xcdiff #{diff_args} -g BUILD_PHASES -t Project -v")
      assert_match "✅ BUILD_PHASES > \"Project\" target\n", out
    end
  end
end