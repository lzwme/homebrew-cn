class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https:railway.com"
  url "https:github.comrailwayappcliarchiverefstagsv4.0.1.tar.gz"
  sha256 "0ba5f198d4f825fb1b035a4c3aa4e1cd334f62cbbf62f1b34517db60f194781d"
  license "MIT"
  head "https:github.comrailwayappcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "481aa114b439f91bd492d5702fd30f1fd3610473bec98a6dade2982a72c47812"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de7dcf9cefd694e661606012f0f7c8102d809c664ec024227e4ea4a10cc0b814"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bc4ab520cb044db19b17cbde14ba0d55c8bf4e83f3c98de4d24b0a65e5c5f1c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c4204889818edb8b6bf53b041213c24413383f92e9f2b14cb0cbf6aa3b3cc3f"
    sha256 cellar: :any_skip_relocation, ventura:       "c4743f07178a9ca45b3e35ef24339d8fe8462997cac0685fdc771d3e4c2efef8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e638e2b3f5b66088e5d1a29e0313f8d9ebbafc4bc8c95efde937bff9550175d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcdde41ee85c98aa3140d44f9e2902a037c027747d4a889b4684433356d5ff85"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"railway", "completion")
  end

  test do
    output = shell_output("#{bin}railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}railway --version").strip
  end
end