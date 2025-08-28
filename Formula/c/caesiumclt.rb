class Caesiumclt < Formula
  desc "Fast and efficient lossy and/or lossless image compression tool"
  homepage "https://github.com/Lymphatus/caesium-clt"
  url "https://ghfast.top/https://github.com/Lymphatus/caesium-clt/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "2ba935780d3798a3047ff87c7b855531ca2472114460704b99191cc069203f07"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3268eac1f13c27ead8eefb2f9e0e8887a729339d5a7a6df0f2c558953753bd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c88e66406675fd8f83851e95b345221d43131cc0a15f23e25e8ef85235f31a16"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60e8022db4f9c2e6d4c00a09740679e996c2e2d5ab5cfc919a0e814447df91d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a236826b7adb2e06ba4715dbc52640a9a919a200c7a2b159da7ed5a9fb4b171"
    sha256 cellar: :any_skip_relocation, ventura:       "748cf3dd29e505e0fceeac9f812f5b196e39455fa7ed1d7224a7be5f7b17098f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e78fb0c25875f369e81779bd980831447766b9650e9f1cd158c25437373f69c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13baa9b40a5634c68f39f830184ce2f01d145639e21db0bf1a630cd3c9c9dba1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"caesiumclt", "--lossless", "-Q", "--suffix", "_t", "--output", testpath, test_fixtures("test.jpg")
    assert_path_exists testpath/"test_t.jpg"
    system bin/"caesiumclt", "-q", "80", "-Q", "--suffix", "_b", "--output", testpath, test_fixtures("test.jpg")
    assert_path_exists testpath/"test_b.jpg"
  end
end