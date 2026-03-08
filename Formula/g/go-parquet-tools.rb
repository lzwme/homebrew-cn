class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https://github.com/hangxie/parquet-tools"
  url "https://ghfast.top/https://github.com/hangxie/parquet-tools/archive/refs/tags/v1.47.7.tar.gz"
  sha256 "61dfb5c8c8c5d388aa30c45ff69507b00712c8d230e76b64f4ead5bb2d43b6d3"
  license "BSD-3-Clause"
  head "https://github.com/hangxie/parquet-tools.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3788d491ae8874243430a8e7cc23895a031ad88eb98e2a726f9425aaa611287a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3788d491ae8874243430a8e7cc23895a031ad88eb98e2a726f9425aaa611287a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3788d491ae8874243430a8e7cc23895a031ad88eb98e2a726f9425aaa611287a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ce1c203c70528542119a9e85450b82997138384efd019505af8a7723f36fc54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61f3e92320921987f8e152ea1db652f09f5d830e651529fe966f3e492d9f1283"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8dcb38abc8b8242ada1912c88a7af24c90fcfdee0c4b6a83fc685b7b5082c6a5"
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