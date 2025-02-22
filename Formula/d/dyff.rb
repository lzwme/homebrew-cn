class Dyff < Formula
  desc "Diff tool for YAML files, and sometimes JSON"
  homepage "https:github.comhomeportdyff"
  url "https:github.comhomeportdyffarchiverefstagsv1.9.4.tar.gz"
  sha256 "77e48f951de76636080bfe067293262a491fd7b26511b189c5c655cdb7c24516"
  license "MIT"
  head "https:github.comhomeportdyff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bd2bafc8986b7ec08c50a975015c8a158a32936492dc47d28fa5c5074cdd4eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bd2bafc8986b7ec08c50a975015c8a158a32936492dc47d28fa5c5074cdd4eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0bd2bafc8986b7ec08c50a975015c8a158a32936492dc47d28fa5c5074cdd4eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "033161a99e49c24b6a1bea9ef77b97a7e10216af324d125535720b2373b502a1"
    sha256 cellar: :any_skip_relocation, ventura:       "033161a99e49c24b6a1bea9ef77b97a7e10216af324d125535720b2373b502a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94019386c95755c6017eb2e968a7f0b2e9c9676a3431f34f295702e512b2606c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comhomeportdyffinternalcmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmddyff"

    generate_completions_from_executable(bin"dyff", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}dyff version")

    (testpath"file1.yaml").write <<~YAML
      name: Alice
      age: 30
    YAML

    (testpath"file2.yaml").write <<~YAML
      name: Alice
      age: 31
    YAML

    output = shell_output("#{bin}dyff between file1.yaml file2.yaml")
    assert_match <<~EOS, output
      age
        ± value change
          - 30
          + 31
    EOS
  end
end