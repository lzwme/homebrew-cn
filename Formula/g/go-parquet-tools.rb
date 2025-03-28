class GoParquetTools < Formula
  desc "Utility to deal with Parquet data"
  homepage "https:github.comhangxieparquet-tools"
  url "https:github.comhangxieparquet-toolsarchiverefstagsv1.27.1.tar.gz"
  sha256 "1e260fe1125682a7f1296efcbab2038d820a8e43b1449f943d1e0c787d669f1d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25906c46d600af510d792dbedd5e13f01e0838eb407571685da2730b4bb42d06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25906c46d600af510d792dbedd5e13f01e0838eb407571685da2730b4bb42d06"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "25906c46d600af510d792dbedd5e13f01e0838eb407571685da2730b4bb42d06"
    sha256 cellar: :any_skip_relocation, sonoma:        "f91b2c350095fa233f2284703c7b1643fb3f9a3f0379afa23632db725f95d0f1"
    sha256 cellar: :any_skip_relocation, ventura:       "f91b2c350095fa233f2284703c7b1643fb3f9a3f0379afa23632db725f95d0f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ae87da8cda0efe12df800e4c622ed622020a86e53d658a50d56635f7d2d721d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comhangxieparquet-toolscmd.version=v#{version}
      -X github.comhangxieparquet-toolscmd.build=#{time.iso8601}
      -X github.comhangxieparquet-toolscmd.source=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin"parquet-tools")
  end

  test do
    resource("test-parquet") do
      url "https:github.comhangxieparquet-toolsraw950d21759ff3bd398d2432d10243e1bace3502c5testdatagood.parquet"
      sha256 "daf5090fbc5523cf06df8896cf298dd5e53c058457e34766407cb6bff7522ba5"
    end

    resource("test-parquet").stage testpath

    output = shell_output("#{bin}parquet-tools schema #{testpath}good.parquet")
    assert_match "name=Parquet_go_root", output
  end
end