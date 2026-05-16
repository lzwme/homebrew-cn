class Kbld < Formula
  desc "Tool for building and pushing container images in development workflows"
  homepage "https://carvel.dev/kbld/"
  url "https://ghfast.top/https://github.com/carvel-dev/kbld/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "8933c86e5a1b214616ef82c75ad2e162df0b217fcc9358c07e9f77d6dc6f95a8"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/kbld.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f25ec9489c43de04d1924f694d7dd4d8ce4b7830feacc6ca11c1de65883a542"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f25ec9489c43de04d1924f694d7dd4d8ce4b7830feacc6ca11c1de65883a542"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f25ec9489c43de04d1924f694d7dd4d8ce4b7830feacc6ca11c1de65883a542"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2605d3464c40c82b53fabd2565690bf584f47189a477ccb92a98bb056f21be5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "820282210681cd6e4c0691b6d3952ab579b58da863f4e9ccb2d7fde3c19ed916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4666cbee00be7a8333979ac615dfa21fdd3a66ed5869e5efca419d39b9b34518"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X carvel.dev/kbld/pkg/kbld/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/kbld"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kbld --version")

    test_yaml = testpath/"test.yml"
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

    output = shell_output("#{bin}/kbld -f #{test_yaml}")
    assert_match "image: index.docker.io/library/nginx@sha256", output
  end
end