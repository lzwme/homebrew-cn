class Awsdac < Formula
  desc "CLI tool for drawing AWS architecture"
  homepage "https:github.comawslabsdiagram-as-code"
  url "https:github.comawslabsdiagram-as-codearchiverefstagsv0.21.5.tar.gz"
  sha256 "92e68b8fc2bee44fc8a943153453ecd4fd86628f41e7564a83444e32fcca1a9c"
  license "Apache-2.0"
  head "https:github.comawslabsdiagram-as-code.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e73b9a8c44ae6644751a1161a74ceda06d1854e6a0213d137a9a146314a3d015"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e73b9a8c44ae6644751a1161a74ceda06d1854e6a0213d137a9a146314a3d015"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e73b9a8c44ae6644751a1161a74ceda06d1854e6a0213d137a9a146314a3d015"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac92fff7b63af4a23ca3b9752c1e9225fdd91f77950aa9d7f97cfc49993a086e"
    sha256 cellar: :any_skip_relocation, ventura:       "ac92fff7b63af4a23ca3b9752c1e9225fdd91f77950aa9d7f97cfc49993a086e"
  end

  depends_on "go" => :build
  depends_on :macos # linux build blocked by https:github.comawslabsdiagram-as-codeissues12

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), ".cmdawsdac"
  end

  test do
    (testpath"test.yaml").write <<~EOS
      Diagram:
        Resources:
          Canvas:
            Type: AWS::Diagram::Canvas
    EOS
    assert_equal "[Completed] AWS infrastructure diagram generated: output.png",
      shell_output("#{bin}awsdac test.yaml").strip
  end
end