class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https:aquaproj.github.io"
  url "https:github.comaquaprojaquaarchiverefstagsv2.44.1.tar.gz"
  sha256 "827eefdd6ee6483ffd368083b54aae33dfb1f9bf5808de3b45dbc12cfc00fc5a"
  license "MIT"
  head "https:github.comaquaprojaqua.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ee1f38e4d23cd8d30c1de7f39c3c3cb025856f4605619fc9931b70944ea604b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ee1f38e4d23cd8d30c1de7f39c3c3cb025856f4605619fc9931b70944ea604b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ee1f38e4d23cd8d30c1de7f39c3c3cb025856f4605619fc9931b70944ea604b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9143d36c45ea971402315b8102ca598507fd95ebba6146b3a46db534e9104f8"
    sha256 cellar: :any_skip_relocation, ventura:       "e9143d36c45ea971402315b8102ca598507fd95ebba6146b3a46db534e9104f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09ee47d7ea9b641e69410cc49c204530e13eadc7f4d6678bfe795a768a8b2728"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), ".cmdaqua"

    generate_completions_from_executable(bin"aqua", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}aqua version")

    system bin"aqua", "init"
    assert_match "depName=aquaprojaqua-registry", (testpath"aqua.yaml").read
  end
end