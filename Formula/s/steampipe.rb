class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://ghfast.top/https://github.com/turbot/steampipe/archive/refs/tags/v2.3.6.tar.gz"
  sha256 "7af266d9834435e1eadf5ffd793a27acbf679bee55d6510d22d2b8307a4a4b60"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f559b67ae268601947f7b33fa66fe3c610f59e4599438dd3babe6d6567997df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b51e96fbcd5609c4dbdc0abaa6c9dc3c79a096760fe693f8538a8b62ab4dec86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1a1d448e471dc9e5c66e363c4f171a609ec9687d8ddd725548c77331303afdc"
    sha256 cellar: :any_skip_relocation, sonoma:        "d283e1f5412a87aecf65df065c23756b4ee803ac21e828eb089388f233477ba6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bb931480390e6222af214b0b878ac85592c2f204f374e91bf0ec31724b4a283"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9b3e8aeff5b699c2b83841e5781613ad4956854586ff7fee819c69f37d63edf"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"steampipe", shell_parameter_format: :cobra)
  end

  test do
    ENV["STEAMPIPE_INSTALL_DIR"] = testpath

    output = shell_output("#{bin}/steampipe service status")
    assert_match "Steampipe service is not installed", output

    assert_match "Steampipe v#{version}", shell_output("#{bin}/steampipe --version")
  end
end