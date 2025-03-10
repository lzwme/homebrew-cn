class Kbld < Formula
  desc "Tool for building and pushing container images in development workflows"
  homepage "https:carvel.devkbld"
  url "https:github.comcarvel-devkbldarchiverefstagsv0.45.0.tar.gz"
  sha256 "06ec0c144ea24f462fad87bd57463e28cf853d6f58a47a434e79a2deb49d23cd"
  license "Apache-2.0"
  head "https:github.comcarvel-devkbld.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "516e60d8536c37a1733172e2a5e950026f97ff66d09820b05196e4e59dd80082"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "516e60d8536c37a1733172e2a5e950026f97ff66d09820b05196e4e59dd80082"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "516e60d8536c37a1733172e2a5e950026f97ff66d09820b05196e4e59dd80082"
    sha256 cellar: :any_skip_relocation, sonoma:        "618fa0ac2340bfcab3ada07fdb70f64c7a7eef31ad8d41b6a30c7bc8dcac2fd5"
    sha256 cellar: :any_skip_relocation, ventura:       "618fa0ac2340bfcab3ada07fdb70f64c7a7eef31ad8d41b6a30c7bc8dcac2fd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e15c17078103f935499e0913a345fb044a77feb5bd7336f90b795a02d5159228"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X carvel.devkbldpkgkbldversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdkbld"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kbld --version")

    test_yaml = testpath"test.yml"
    test_yaml.write <<~YAML
      ---
      apiVersion: v1
      kind: Pod
      metadata:
        name: test
      spec:
        containers:
        - name: test
          image: nginx:1.14.2
    YAML

    output = shell_output("#{bin}kbld -f #{test_yaml}")
    assert_match "image: index.docker.iolibrarynginx@sha256", output
  end
end