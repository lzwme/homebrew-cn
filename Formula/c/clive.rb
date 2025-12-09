class Clive < Formula
  desc "Automates terminal operations"
  homepage "https://github.com/koki-develop/clive"
  url "https://ghfast.top/https://github.com/koki-develop/clive/archive/refs/tags/v0.12.16.tar.gz"
  sha256 "a08e5143d657a236edd1d90332b4d8c8e8a1899480b595fd8688678a86d7db84"
  license "MIT"
  head "https://github.com/koki-develop/clive.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be627ba710546e0407e1774fa1797a4fd0a33a092a44172531491974d8eae57c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be627ba710546e0407e1774fa1797a4fd0a33a092a44172531491974d8eae57c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be627ba710546e0407e1774fa1797a4fd0a33a092a44172531491974d8eae57c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e6f1c9a2268c7c7be97b7abe8bc87a93a7dfd11f7fbf5fe5ad54c6c0316c017"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2045675e3d8b5535d1da74e9d9406c9ab7263aa39cb54cbcb45c66020b590d08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8a9ddf715e85b87e4518a2286794499e279f282eeb4ce87d05407a81497b3e5"
  end

  depends_on "go" => :build
  depends_on "ttyd"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/clive/cmd.version=v#{version}")
    generate_completions_from_executable(bin/"clive", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    system bin/"clive", "init"
    assert_path_exists testpath/"clive.yml"

    system bin/"clive", "validate"
    assert_match version.to_s, shell_output("#{bin}/clive --version")
  end
end