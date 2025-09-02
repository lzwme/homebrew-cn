cask "cuda-z" do
  version "0.10.251"
  sha256 "552081ce1f632a72231dedeb6c3ddb02b352d0b19eea45f9ae27d930ee9d7c35"

  url "https://downloads.sourceforge.net/cuda-z/CUDA-Z-#{version}.dmg"
  name "CUDA-Z"
  desc "Show basic information about CUDA-enabled GPUs and GPGPUs"
  homepage "https://cuda-z.sourceforge.net/"

  deprecate! date: "2024-09-01", because: :unmaintained
  disable! date: "2025-09-02", because: :unmaintained

  depends_on arch: :x86_64

  app "CUDA-Z.app"
end