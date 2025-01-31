class Awsdac < Formula
  desc "CLI tool for drawing AWS architecture"
  homepage "https:github.comawslabsdiagram-as-code"
  url "https:github.comawslabsdiagram-as-codearchiverefstagsv0.21.8.tar.gz"
  sha256 "3ebd046ecbbe1b0e66adf501dcf9e0d42e627ad6a2318f8f4a9ec047e28b1c7c"
  license "Apache-2.0"
  head "https:github.comawslabsdiagram-as-code.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bb67b966b698a1a769477b2d31ad17d5ef339983c3522db9949f0cb7452a8b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bb67b966b698a1a769477b2d31ad17d5ef339983c3522db9949f0cb7452a8b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2bb67b966b698a1a769477b2d31ad17d5ef339983c3522db9949f0cb7452a8b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "995edb7b24fc13b39c56d62af45779a6717df133e453722999b6c577da1d313c"
    sha256 cellar: :any_skip_relocation, ventura:       "995edb7b24fc13b39c56d62af45779a6717df133e453722999b6c577da1d313c"
  end

  depends_on "go" => :build
  depends_on :macos # linux build blocked by https:github.comawslabsdiagram-as-codeissues12

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), ".cmdawsdac"
  end

  test do
    (testpath"test.yaml").write <<~YAML
      Diagram:
        Resources:
          Canvas:
            Type: AWS::Diagram::Canvas
    YAML
    assert_equal "[Completed] AWS infrastructure diagram generated: output.png",
      shell_output("#{bin}awsdac test.yaml").strip
  end
end