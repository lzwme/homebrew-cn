class Wails < Formula
  desc "Create beautiful applications using Go"
  homepage "https://wails.io"
  url "https://ghfast.top/https://github.com/wailsapp/wails/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "57961d21f74e2752c609d0a0f63f32cf7e910d76a006309ccd1b92fc64112227"
  license "MIT"
  head "https://github.com/wailsapp/wails.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00c9eaa273abe24a0972c0284768170a4d33b95c3137db30a34d38fc104f376e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00c9eaa273abe24a0972c0284768170a4d33b95c3137db30a34d38fc104f376e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00c9eaa273abe24a0972c0284768170a4d33b95c3137db30a34d38fc104f376e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4069d1b28ed1089aca6ae1131f9c3b2d432e5204f5264690037e1e95d5bd4bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6dfe8f85f9bc1fdaf022672bcb998d980ed7b4e8d78e358522622eaef0d03e09"
    sha256 cellar: :any,                 x86_64_linux:  "8e739126a3bcf02df0fe84fb500389cca3a2914e2a2aa43813784d2e2318e8a6"
  end

  depends_on "go"

  def install
    # The top-level go.work only lists v3, so disable workspace mode to build v2.
    ENV["GOWORK"] = "off"
    cd "v2" do
      system "go", "build", *std_go_args, "./cmd/wails"
    end
  end

  test do
    ENV["NO_COLOR"] = "1"

    output = shell_output("#{bin}/wails init -n brewtest 2>&1")
    assert_match "# Initialising Project 'brewtest'", output
    assert_match "Template          | Vanilla + Vite", output

    assert_path_exists testpath/"brewtest/go.mod"
    assert_equal "brewtest", JSON.parse((testpath/"brewtest/wails.json").read)["name"]

    assert_match version.to_s, shell_output("#{bin}/wails version")
  end
end