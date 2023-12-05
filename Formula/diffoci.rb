class Diffoci < Formula
  desc "Diff for Docker and OCI container images"
  homepage "https://github.com/reproducible-containers/diffoci"
  url "https://ghproxy.com/https://github.com/reproducible-containers/diffoci/releases/download/v0.1.4/diffoci-v0.1.4.darwin-amd64"
  sha256 "2885914332f08df4349a7984ca1812b11710c8868572716fbdc6c94531d13591"
  license "Apache-2.0"

  def install
    bin.install "diffoci-v0.1.2.darwin-amd64" => "diffoci"
  end

  test do
    system "#{bin}/diffoci", "--version"
  end
end