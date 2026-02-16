class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.47.0.tar.gz"
  sha256 "2e6bef5c182ffe2d2c9c412be43fee7f06cf19d344896b63a57f73cf8ee46e00"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0541d01b515fa856f27112112b443cd98293b53211a3a0410daf1f1c5a0e9953"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0541d01b515fa856f27112112b443cd98293b53211a3a0410daf1f1c5a0e9953"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0541d01b515fa856f27112112b443cd98293b53211a3a0410daf1f1c5a0e9953"
    sha256 cellar: :any_skip_relocation, sonoma:        "303b2ca00f0579953b88017c0fa3b6ec2e124e2c6033b483e4fdc07288a322c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19b4f9f542dd3ead1062b353af5c85885ce13535ca4c9530ff47bffc6e6e7f91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7dbb5d3725bc8a230780e1c6b448ac5be12b9bc1313079df3add95d7e91c132b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hangxie/parquet-tools/cmd/version.version=v#{version}
      -X github.com/hangxie/parquet-tools/cmd/version.build=#{time.iso8601}
      -X github.com/hangxie/parquet-tools/cmd/version.source=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"parquet-tools")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/parquet-tools version")

    resource("test-parquet") do
      url "https://github.com/hangxie/parquet-tools/raw/950d21759ff3bd398d2432d10243e1bace3502c5/testdata/good.parquet"
      sha256 "daf5090fbc5523cf06df8896cf298dd5e53c058457e34766407cb6bff7522ba5"
    end

    resource("test-parquet").stage testpath

    output = shell_output("#{bin}/parquet-tools schema #{testpath}/good.parquet")
    assert_match "name=parquet_go_root", output
  end
end