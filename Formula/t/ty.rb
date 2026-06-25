class Ty < Formula
  desc "Extremely fast Python type checker, written in Rust"
  homepage "https://docs.astral.sh/ty/"
  url "https://files.pythonhosted.org/packages/5d/84/4417eb08328dcc547bf407d20af5e45ec8c64a85470f388fc2d590c9200a/ty-0.0.52.tar.gz"
  sha256 "f1191175429fea917f96f79a57773eb6e57b861ee97e9ad2d77cc7538f0f284b"
  license "MIT"
  head "https://github.com/astral-sh/ty.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f62ac3e5764d55a9c40931240b62ddb18db2c0949f41b57ca319f420be33080b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f8a46c8222ea72e3eda9851a678cf782c49b7e2299b61a634019a0357958bd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19ea825e0d45578caeca64578db115b184d3d838c1efbd7f20ee13af18d39ef1"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f558befe30501e403248d55b5b6c95a4b00e4bd8ed42edcaab551bba2fd2823"
    sha256 cellar: :any,                 arm64_linux:   "7df1484ee34dfce73262fb12e6ca02d6b445079990fd004729544f6e3a7a6ae4"
    sha256 cellar: :any,                 x86_64_linux:  "9861150c946f6e686406224d791e253793a0800ff0401cd0233f4875b897d012"
  end

  depends_on "rust" => :build

  def install
    ENV["TY_COMMIT_SHORT_HASH"] = tap.user
    ENV["TY_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", *std_cargo_args(path: "ruff/crates/ty")
    generate_completions_from_executable(bin/"ty", "generate-shell-completion")
  end

  test do
    assert_match version.major_minor_patch.to_s, shell_output("#{bin}/ty --version")

    (testpath/"bad.py").write <<~PYTHON
      def f(x: int) -> str:
          return x
    PYTHON

    output = shell_output("#{bin}/ty check #{testpath} 2>&1", 1)
    assert_match "error[invalid-return-type]: Return type does not match returned value", output
  end
end