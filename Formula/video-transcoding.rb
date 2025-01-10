class VideoTranscoding < Formula
  desc "Tools to transcode, inspect and convert videos"
  homepage "https:github.comlisameltonvideo_transcoding"
  url "https:github.comlisameltonvideo_transcodingarchiverefstags2025.01.09.tar.gz"
  sha256 "13310dfa984acd3c7fe473f8a531076e70cfb55fd9caf0ec34bf28b868934032"
  license "MIT"

  depends_on "ffmpeg"
  depends_on "handbrake"

  uses_from_macos "ruby"

  def install
    bin.install "transcode-video.rb" => "transcode-video"
    bin.install "detect-crop.rb" => "detect-crop"
    bin.install "convert-video.rb" => "convert-video"
  end
end